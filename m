From: "Norm Legit" <normlegit@gmail.com>
Subject: Re: Question regarding superblocks
Date: Sun, 27 Aug 2006 22:27:38 -0700
Message-ID: <e5b4df2e0608272227t23dd7258sc940dd7e07459609@mail.gmail.com>
References: <e5b4df2e0608271850i2019f223ybd58e635336f5ea6@mail.gmail.com>
	 <17650.20000.949138.131523@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17650.20000.949138.131523@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phenomenal, thank you so much!  This worked perfectly!!

-  Norm

On 8/27/06, Neil Brown <neilb@suse.de> wrote:
> On Sunday August 27, normlegit@gmail.com wrote:
> > Hi,
> >
> > I created a raid5 array with 3 devices.  Unfortunately, I carelessly used
> > the "--zero-superblock" option with mdadm to remove all of the superblock.
> > I still have the mdadm.conf file which has the uuid in it.  Is there a way
> > for me to rebuild the superblocks or recover the data on these drives?
>
> Just recreate the array with the same devices in the same order and
> the same chunk size.  All your data should still be there.
>
> NeilBrown
>
