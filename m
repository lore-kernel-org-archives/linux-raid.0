From: Norman Schmidt <norman.schmidt@ratnet.stw.uni-erlangen.de>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 17:37:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F9E9B4D.4000600@ratnet.stw.uni-erlangen.de>
References: <3F9DAD4C.3000002@verizon.net> <200310281506.32013.maarten@vbvb.nl> <Pine.LNX.4.56.0310281418490.25548@unicorn.drogon.net> <200310281605.30225.maarten@vbvb.nl>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310281605.30225.maarten@vbvb.nl>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

maarten van den Berg schrieb:

>>The cards I have identify in /proc/pci as:
>>
>>  Unknown mass storage controller: Promise Technology, Inc. 20269 (#2) (rev
>>2)
> 
> 
> That's an Ultra 133 TX, I have the same one.
> 
> 
>>They aren't RAID cards (as far as I'm aware!) and I needed to apply the AC
>>patches to 2.4.20 to get them to be recognised. (These patches are
>>integrated into 2.4.22)
> 
> 
> Hmm.  Ok.  Weird...  My antique SuSE linux distro 7.3 recognized them right 
> away, and so did the latest SuSE 8.2 I installed over that yesterday.
> SuSE has been known to apply a lot of patches to their kernel though...

I use a plain kernel.org 2.4.22 kernel with tw0 Ultra133 and one 
Ultra100 in one server. It works without problems. Are you sure you 
activated ATA/IDE/MFM/RLL -> IDE, ATA and ATAPI Block devices -> PROMISE 
PDC202(68|69|70|71|75|76|77)?

That should do the trick.

Hope this helps, Norman.
-- 
--

Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem.             Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg

