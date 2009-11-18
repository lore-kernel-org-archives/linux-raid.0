From: Erwan MAS <erwan@mas.nom.fr>
Subject: Re: Raid10 layout
Date: Thu, 19 Nov 2009 00:44:00 +0100
Message-ID: <20091118234400.GL1863@voyageur.mas.nom.fr>
References: <20091118133803.GH1863@voyageur.mas.nom.fr> <20091118140413.GE17713@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091118140413.GE17713@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 18, 2009 at 02:04:13PM +0000, Robin Hill wrote:
> My understanding is that the layout should be (using your ordering):
> 
> A C B D
> 1 2 3 4
> 5 6 7 8
> . . . .
> . . . .
> 4 1 2 3
> 8 5 6 7
> . . . .
> . . . .
> 
> Allowing the loss of A & B, or C & D.
> 
> Is this not what you're seeing on-disk?

It's ok .

My error was in the  compute of the offset , i starting from physical device size but i have 
not include the bitmap .
So when i starting from array device size , it's ok .

-- 
     ____________________________________________________________
    / Erwan MAS                                                 /\
   | mailto:erwan@mas.nom.fr                                   |_/
___|________________________________________________________   |
\___________________________________________________________\__/
