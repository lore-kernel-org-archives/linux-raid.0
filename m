From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Mon, 5 Jun 2017 11:24:54 +0200
Message-ID: <20170605092454.GA3651@metamorpher.de>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
 <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
 <20170603232919.GA17108@metamorpher.de>
 <b8b6eb18-2952-86ee-5329-9e4f4c406c3d@tonel.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b8b6eb18-2952-86ee-5329-9e4f4c406c3d@tonel.li>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Tonelli <paul@tonel.li>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 05, 2017 at 12:58:03AM +0200, Paul Tonelli wrote:
> I  did find this one at that exact offset 26096 = (133169664 - 512)/512 

26096->260096? Okay.

> Now, after doing a pvcreate and a vgcfgrestore ...

Should not be necessary if the data on two drives was okay? 
You did leave the dd-overwritten drive out as missing, right? 
Do you have the correct disk order and chunk size and offset?

You have to be 140% sure the RAID itself is running correctly, 
otherwise all other steps are bound to fail.

If you run photorec on the RAID and it manages to recover 
a file that is larger than number of drives * chunk size 
and intact, you can have some confidence the RAID is okay 
in terms of disk order and chunk size - the offset may 
still be off by multiple of stripe alignment but if the 
offset is correct too, file -s /dev/md0 should say LVM PV 
in your case.

Regards
Andreas Klauer
