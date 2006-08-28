From: Neil Brown <neilb@suse.de>
Subject: Re: Question regarding superblocks
Date: Mon, 28 Aug 2006 12:00:00 +1000
Message-ID: <17650.20000.949138.131523@cse.unsw.edu.au>
References: <e5b4df2e0608271850i2019f223ybd58e635336f5ea6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Norm Legit on Sunday August 27
Sender: linux-raid-owner@vger.kernel.org
To: Norm Legit <normlegit@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday August 27, normlegit@gmail.com wrote:
> Hi,
> 
> I created a raid5 array with 3 devices.  Unfortunately, I carelessly used
> the "--zero-superblock" option with mdadm to remove all of the superblock.
> I still have the mdadm.conf file which has the uuid in it.  Is there a way
> for me to rebuild the superblocks or recover the data on these drives?

Just recreate the array with the same devices in the same order and
the same chunk size.  All your data should still be there.

NeilBrown
