From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Checking consistency of Linux software RAID
Date: Mon, 30 Jun 2003 14:28:57 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0306301425030.31613-100000@unicorn.drogon.net>
References: <20030630131655.GE12240@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030630131655.GE12240@marowsky-bree.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 30 Jun 2003, Lars Marowsky-Bree wrote:

> On 2003-06-30T14:13:57,
>    Gordon Henderson <gordon@drogon.net> said:
>
> > Try
> >
> > 	badblocks -v -s /dev/md0
>
> This won't do what he asked.

You are pedantically correct, but in the absence of anything else, at
least it could form a partial solution and let him know that a problem
exists which could them be actioned in some way before it becomes data
threatening.

Gordon


