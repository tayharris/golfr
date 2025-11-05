#!/usr/bin/env python3
"""
Discord Bot Example for golfr Package
======================================

This example shows how to create a Discord bot that uses the golfr R package
to generate and share golf analytics graphics. The bot responds to commands
and calls R functions to generate branded PNG images.

Requirements:
- discord.py (pip install discord.py)
- rpy2 (pip install rpy2)
- R with golfr package installed
- DataGolf API key set as DATAGOLF_API_KEY environment variable

Setup:
1. Create a Discord application at https://discord.com/developers/applications
2. Create a bot and get the token
3. Set DISCORD_BOT_TOKEN environment variable
4. Install golfr package in R: devtools::install_github("tayharris/golfr")
5. Run this script: python discord_bot_example.py
"""

import os
import discord
from discord.ext import commands
from rpy2 import robjects
from rpy2.robjects.packages import importr

# Load R and golfr package
base = importr('base')
golfr = importr('golfr')

# Set up Discord bot
intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix='!golf ', intents=intents)


@bot.event
async def on_ready():
    """Called when bot successfully connects to Discord."""
    print(f'{bot.user} has connected to Discord!')
    print(f'Servers: {len(bot.guilds)}')


@bot.command(name='weekly')
async def weekly_bundle(ctx, tour: str = 'pga'):
    """
    Generate all weekly graphics.

    Usage: !golf weekly [tour]
    Example: !golf weekly pga
    """
    await ctx.send(f"⛳ Generating weekly golf graphics for {tour.upper()} tour...")

    try:
        # Call R function to generate graphics bundle
        output_dir = "./discord_graphics"
        golfr.create_weekly_bundle(tour=tour, output_dir=output_dir)

        # Send each generated image
        graphics = [
            'win_probabilities.png',
            'skill_ratings.png',
            'sg_heatmap.png',
            'market_edge.png',
            'best_bets.png'
        ]

        for graphic in graphics:
            filepath = os.path.join(output_dir, graphic)
            if os.path.exists(filepath):
                await ctx.send(file=discord.File(filepath))

        await ctx.send("✅ Weekly graphics complete!")

    except Exception as e:
        await ctx.send(f"❌ Error generating graphics: {str(e)}")


@bot.command(name='edge')
async def market_edge(ctx, tour: str = 'pga', market: str = 'win', top_n: int = 15):
    """
    Show market edge analysis (DataGolf vs betting markets).

    Usage: !golf edge [tour] [market] [top_n]
    Example: !golf edge pga win 20
    """
    await ctx.send(f"📊 Analyzing {market} market edge for {tour.upper()}...")

    try:
        # Generate plot
        r_code = f"""
        library(golfr)
        p <- plot_market_edge(tour='{tour}', market='{market}', top_n={top_n})
        filepath <- save_plot_discord(p, 'market_edge_temp.png', output_dir='./discord_graphics')
        filepath
        """
        filepath = str(robjects.r(r_code)[0])

        if os.path.exists(filepath):
            await ctx.send(file=discord.File(filepath))
            os.remove(filepath)  # Clean up

    except Exception as e:
        await ctx.send(f"❌ Error: {str(e)}")


@bot.command(name='bets')
async def best_bets(ctx, tour: str = 'pga', min_edge: float = 2.0):
    """
    Show best betting value picks.

    Usage: !golf bets [tour] [min_edge]
    Example: !golf bets pga 3.0
    """
    await ctx.send(f"💰 Finding best bets for {tour.upper()} (min {min_edge}% edge)...")

    try:
        r_code = f"""
        library(golfr)
        p <- plot_best_bets(tour='{tour}', min_edge={min_edge})
        filepath <- save_plot_discord(p, 'best_bets_temp.png', output_dir='./discord_graphics')
        filepath
        """
        filepath = str(robjects.r(r_code)[0])

        if os.path.exists(filepath):
            await ctx.send(file=discord.File(filepath))
            os.remove(filepath)

    except Exception as e:
        await ctx.send(f"❌ Error: {str(e)}")


@bot.command(name='spotlight')
async def player_spotlight(ctx, *players):
    """
    Show detailed player spotlight (1-4 players).

    Usage: !golf spotlight <player1> [player2] [player3] [player4]
    Example: !golf spotlight "Scottie Scheffler" "Rory McIlroy"
    """
    if not players or len(players) > 4:
        await ctx.send("❌ Please provide 1-4 player names in quotes.")
        return

    players_str = ', '.join([f'"{p}"' for p in players])
    await ctx.send(f"🏌️ Creating spotlight for: {', '.join(players)}...")

    try:
        r_code = f"""
        library(golfr)
        p <- plot_player_spotlight(players=c({players_str}))
        filepath <- save_plot_discord(p, 'spotlight_temp.png', output_dir='./discord_graphics')
        filepath
        """
        filepath = str(robjects.r(r_code)[0])

        if os.path.exists(filepath):
            await ctx.send(file=discord.File(filepath))
            os.remove(filepath)

    except Exception as e:
        await ctx.send(f"❌ Error: {str(e)}")


@bot.command(name='skills')
async def skill_ratings(ctx, tour: str = 'pga', top_n: int = 10):
    """
    Show skill ratings comparison for top players.

    Usage: !golf skills [tour] [top_n]
    Example: !golf skills pga 15
    """
    await ctx.send(f"📈 Generating skill ratings for top {top_n} players...")

    try:
        r_code = f"""
        library(golfr)
        p <- plot_skill_ratings(top_n={top_n})
        filepath <- save_plot_discord(p, 'skills_temp.png', output_dir='./discord_graphics')
        filepath
        """
        filepath = str(robjects.r(r_code)[0])

        if os.path.exists(filepath):
            await ctx.send(file=discord.File(filepath))
            os.remove(filepath)

    except Exception as e:
        await ctx.send(f"❌ Error: {str(e)}")


@bot.command(name='heatmap')
async def sg_heatmap(ctx, top_n: int = 15):
    """
    Show strokes gained heatmap.

    Usage: !golf heatmap [top_n]
    Example: !golf heatmap 20
    """
    await ctx.send(f"🔥 Creating strokes gained heatmap...")

    try:
        r_code = f"""
        library(golfr)
        p <- plot_sg_heatmap(top_n={top_n})
        filepath <- save_plot_discord(p, 'heatmap_temp.png', output_dir='./discord_graphics')
        filepath
        """
        filepath = str(robjects.r(r_code)[0])

        if os.path.exists(filepath):
            await ctx.send(file=discord.File(filepath))
            os.remove(filepath)

    except Exception as e:
        await ctx.send(f"❌ Error: {str(e)}")


@bot.command(name='winprobs')
async def win_probabilities(ctx, tour: str = 'pga', top_n: int = 15):
    """
    Show tournament win probabilities.

    Usage: !golf winprobs [tour] [top_n]
    Example: !golf winprobs pga 20
    """
    await ctx.send(f"🏆 Generating win probabilities for {tour.upper()}...")

    try:
        r_code = f"""
        library(golfr)
        p <- plot_win_probabilities(tour='{tour}', top_n={top_n})
        filepath <- save_plot_discord(p, 'winprobs_temp.png', output_dir='./discord_graphics')
        filepath
        """
        filepath = str(robjects.r(r_code)[0])

        if os.path.exists(filepath):
            await ctx.send(file=discord.File(filepath))
            os.remove(filepath)

    except Exception as e:
        await ctx.send(f"❌ Error: {str(e)}")


@bot.command(name='rankings')
async def rankings(ctx, top_n: int = 20):
    """
    Show DataGolf world rankings.

    Usage: !golf rankings [top_n]
    Example: !golf rankings 30
    """
    await ctx.send(f"🌍 Generating top {top_n} rankings...")

    try:
        r_code = f"""
        library(golfr)
        p <- plot_rankings(top_n={top_n})
        filepath <- save_plot_discord(p, 'rankings_temp.png', output_dir='./discord_graphics')
        filepath
        """
        filepath = str(robjects.r(r_code)[0])

        if os.path.exists(filepath):
            await ctx.send(file=discord.File(filepath))
            os.remove(filepath)

    except Exception as e:
        await ctx.send(f"❌ Error: {str(e)}")


# Custom help command
@bot.command(name='commands')
async def show_commands(ctx):
    """Show all available golf commands."""
    help_text = """
⛳ **Golf Analytics Bot Commands** ⛳

📦 **Bundles:**
• `!golf weekly [tour]` - Generate all weekly graphics

📊 **Market Analysis:**
• `!golf edge [tour] [market] [top_n]` - Market edge analysis
• `!golf bets [tour] [min_edge]` - Best betting value picks

🏌️ **Player Analysis:**
• `!golf spotlight <player1> [player2]...` - Player spotlight (1-4 players)
• `!golf skills [tour] [top_n]` - Skill ratings comparison

📈 **Tournament Graphics:**
• `!golf winprobs [tour] [top_n]` - Win probabilities
• `!golf rankings [top_n]` - World rankings
• `!golf heatmap [top_n]` - Strokes gained heatmap

**Tours:** pga, euro, liv, opp, kft
**Markets:** win, top_5, top_10, top_20, make_cut

💡 All graphics include DataGolf data and package branding!
    """
    await ctx.send(help_text)


if __name__ == '__main__':
    # Get bot token from environment
    token = os.getenv('DISCORD_BOT_TOKEN')

    if not token:
        print("Error: DISCORD_BOT_TOKEN environment variable not set")
        exit(1)

    # Run bot
    bot.run(token)
