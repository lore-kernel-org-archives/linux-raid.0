From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md confused by changing device names?
Date: Fri, 8 Oct 2004 09:24:30 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16741.53294.795263.136032@cse.unsw.edu.au>
References: <16ADEDFA-1898-11D9-B27F-00039363AEBE@bitart.com>
	<16741.51528.247736.520728@cse.unsw.edu.au>
	<8A1A64EE-18B4-11D9-B27F-00039363AEBE@bitart.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gerd Knops on Thursday October 7
To: gerti-raid@bitart.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 7, gerti@bitart.com wrote:
> >> Now when md starts it accepts sda1, kicks off sdb1 as outdated, and
> >> never seems to even look at sdc1. Hence it will not start the array.
> >
> > Let me guess:  You are using "raidstart" to start the array.
> > Don't.  It doesn't work.
> > Use "mdadm".  It does.
> >
> Actually in the first round of tests I used mdadm, and in the same 
> situation it just segfaults.
> 

Well, that is something I can help with.  
Can you try again and get an 'strace' showing where the segfault is,
or a gdb stacktrace from the core file??

NeilBrown
