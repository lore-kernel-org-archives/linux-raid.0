From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ADD_NEW_DISK failed
Date: Mon, 24 Feb 2003 07:35:36 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15961.12440.64252.132242@notabene.cse.unsw.edu.au>
References: <5.1.0.14.0.20030223085025.00b08b30@psimail.spindrift.on.ca>
	<3E58EBA1.7010305@ratnet.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Norman Schmidt on Sunday February 23
To: schmidt@naa.net
Cc: Victor Geller <vgeller@spindrift.on.ca>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday February 23, norman.schmidt@ratnet.stw.uni-erlangen.de wrote:
> 
> By the way: This failed-disk approach is not so well documented for 
> mdadm, or did I overlook something? Any documentation anywhere?
> 

Fourth paragraph of the "CREATE MODE" section:

       To create a "degraded" array in which some devices are missing,  simply
       give the word missing in place of a device name.  This will cause mdadm
       to leave the corresponding slot in the array empty.   For  a  RAID4  or
       RAID5  array  at most one slot can be missing.  For a RAID1 array, only
       one real device needs to be given.  All of the others can be missing.


If that is not clear, please help me re-phrase it.


NeilBrown
