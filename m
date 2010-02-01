From: Asdo <asdo@shiftmail.org>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster !!
Date: Mon, 01 Feb 2010 13:45:53 +0100
Message-ID: <4B66CD01.7040202@shiftmail.org>
References: <4B5F6C73.30707@texsoft.it>
 <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene>
 <4B647E0E.6050609@texsoft.it> <4B64A779.6070809@shiftmail.org>
 <4B65943A.4040800@shiftmail.org> <4B66B367.6030803@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B66B367.6030803@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Giovanni Tessore wrote:
> If you have a degraded array which gets an unrecoverable read error, 
> reconstruction is not feasible any more, the disk is mark failed and 
> the whole array fails. The you have to recreate with --force or 
> --assume-clean, start to backup data.. but on each other read errors 
> you get the array offline again ... recreate in --force mode .. and so 
> on (which needs skill and it's error prone).
> Maybe would be useful to have unrecoverable read errors on degraded 
> array to:
> 1) sent a big alert to admin, with detailed info
> 2) don't fail the disk and whole array, but set it into readonly mode
> 3) report read errors to the OS (as for a single drive)
>
> This would allow to do a partial backup and save as most data as 
> possible without having to tamper with create --force etc..
> Experienced use may still try to overcome the situation readding 
> devices (maybe one gone out simply due to timeout), with create 
> --force, etc.. but many persons may have big troubles doing so, and 
> they just see all their data gone, when just a few sectors over many 
> Tb are unreadable and most data cab be saved.

I think if you set it to readonly mode, it wouldn't degrade further even 
on read error.
I think I saw this from the source code, but now I'm not really sure any 
more.
Do you want to check?

If what I say is correct, you can get data out relatively easily with 1 
operation. The array won't go down.
