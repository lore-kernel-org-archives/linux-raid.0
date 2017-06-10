From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Sat, 10 Jun 2017 22:41:05 +0200
Message-ID: <20170610204105.GA19409@metamorpher.de>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
 <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
 <20170603232919.GA17108@metamorpher.de>
 <b8b6eb18-2952-86ee-5329-9e4f4c406c3d@tonel.li>
 <20170605092454.GA3651@metamorpher.de>
 <dfa4dd0d-c68a-4e1b-aac7-649f7f1a72f6@tonel.li>
 <20170605235619.GA8478@metamorpher.de>
 <5f9ed8be-ec90-17bc-3e45-0721689a62a8@tonel.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5f9ed8be-ec90-17bc-3e45-0721689a62a8@tonel.li>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Tonelli <paul@tonel.li>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jun 10, 2017 at 10:04:16PM +0200, Paul Tonelli wrote:
> I believe the offset we manually specify is after the default one on a 
> raid assembly with 3 disks, so it should have rebuilt the previous LVM 
> superblock, or am I missing something (again).

It should be the reverse. When you grow the raid, the offset shrinks.

Not able to provide further insights. You have a LVM2 header which, 
given the correct offset, should appear on the /dev/md device and 
in that case everything else should appear too.

If that is not the case then things will be a lot more complicated.

Regards
Andreas Klauer
