From: aragonx@dcsnow.com
Subject: Re: How to boost performance
Date: Fri, 18 Jun 2010 13:55:41 -0400
Message-ID: <ccb4516c0633bda40a3160130d385c2b.squirrel@www.dcsnow.com>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
    <20100617100109.32a20ffa@natsu>
    <d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
    <20100617221300.3e30afe0@natsu>
    <db120b2f917a2de03cbb3834ef56be7f.squirrel@www.dcsnow.com>
    <20100618020220.161c54b2@natsu> <20100617204327.GA21864@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100617204327.GA21864@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Fri, Jun 18, 2010 at 02:02:20AM +0600, Roman Mamedov wrote:
> actually raid5 sequential reads can be faster than n-1 times the slowest
> disk,
> as it may skip the parity blocks faster than it could read them. Not much,
> probably.

Hello all,

So would I be correct in concluding that I am CPU bound at this point?  My
machine is busy creating the parity information so can not receive any
faster.  A CPU replacement is in order but I have one question in that
direction.  It appears that the md0 process is only using one core.  Is
this because it is a single file being written?  Should it be using both?

The main thrust of this question is which type of CPU upgrade will help my
situation.  I could go for a faster MHz or more cores.  Actually, I can't
go much faster on the MHz front.  I think 3.4GHz is max and I'm at 3.0GHz.

As always, thank you for all your advice.

---
Will Y.


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

