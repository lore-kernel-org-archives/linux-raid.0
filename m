From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Mon, 14 Jan 2013 13:45:57 -0600
Message-ID: <50F46075.2090903@hardwarefreak.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <1358121900.3019.1.camel@workstation-home> <201301140158.27135.thomas@fjellstrom.ca> <201301141122.15322.thomas@fjellstrom.ca>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301141122.15322.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: Tommy Apel Hansen <tommyapeldk@gmail.com>, Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/14/2013 12:22 PM, Thomas Fjellstrom wrote:

> This is the initial single 8MB chunk size test
> 
>                                                             random  random    
> bkwd   record   stride                                   
>               KB  reclen   write rewrite    read    reread    read   write    
> read  rewrite     read   fwrite frewrite   fread  freread
>         33554432    8192  124664  121973   524509   527971  376880  104357  
> 336083    40088   392683   213941   215453  631122   631617

Thomas, if you can't paste a data table into an email such that folks
can actually read it, try a paste bin.  Sending this junk demonstrates a
lack of respect for fellow technical users here-- assuming they have or
will take time to decipher this.  I won't even bother to tackle your
lack of trim posting 3 page emails when replying with a single sentence...

It's bad enough that you require so much hand holding for a simple home
server array, but then you expect us to assemble puzzles in order to
assist you?  This is absurd.  By doing this you're asking to be treated
like a child, asking us to wipe your nose for you.

I'm not being 'hostile' here but REAL.  Cowboy up and get it together.
Don't retort, don't give excuses.  Just take your licks, bite your
tongue, and resolve yourself to get this stuff right from now on.  It's
simple list etiquette, courtesy.  If it's worth your time to send an
email with an Iozone output table, then it's worth taking a little extra
time formatting it so folks can read it.

-- 
Stan

