From: Adam Luter <luterac@bellsouth.net>
Subject: Re: ADD_NEW_DISK failed
Date: Sun, 23 Feb 2003 14:51:56 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030223205156.GB774@smeagol>
References: <5.1.0.14.0.20030223085025.00b08b30@psimail.spindrift.on.ca> <3E58EBA1.7010305@ratnet.stw.uni-erlangen.de> <15961.12440.64252.132242@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15961.12440.64252.132242@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just add "" around missing:

... give the word "missing" in place ...

-Adam Luter

On Mon, Feb 24, 2003 at 07:35:36AM +1100, Neil Brown wrote:
> Fourth paragraph of the "CREATE MODE" section:
> 
>        To create a "degraded" array in which some devices are missing,  simply
>        give the word missing in place of a device name.  This will cause mdadm
>        to leave the corresponding slot in the array empty.   For  a  RAID4  or
>        RAID5  array  at most one slot can be missing.  For a RAID1 array, only
>        one real device needs to be given.  All of the others can be missing.
