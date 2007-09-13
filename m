From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: [linux-lvm] Q: Online resizing ext3 FS
Date: Thu, 13 Sep 2007 15:02:43 +0200
Message-ID: <87abrqn2fg.fsf@informatik.uni-tuebingen.de>
References: <Pine.LNX.4.44.0709121600080.1583-100000@bmsred.bmsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0709121600080.1583-100000@bmsred.bmsi.com> (Stuart
	D. Gathman's message of "Wed, 12 Sep 2007 16:04:21 -0400 (EDT)")
Sender: linux-raid-owner@vger.kernel.org
To: "Stuart D. Gathman" <stuart@bmsi.com>
Cc: LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Stuart D. Gathman" <stuart@bmsi.com> writes:

> On Wed, 12 Sep 2007, Hiren Joshi wrote:
>
>> Has anyone of you been using ext2online to resize (large) ext3
>> filesystems?
>> I have to do it going from 500GB to 1TB on a productive system I was
>> wondering if you have some horror/success stories.
>> I'm using RHEL4/U4 (kernel 2.6.9) on this system.
>
> This brings up an LVM related question I've had.  Can I do this:
>
>   1) take snapshot of 500GB LV
>   2) resize source LV to 1TB
>   3) run ext2online
>   4a) resize succeeds - remove shapshot
>   4b) resize fails horribly - copy shapshot to LV and restart
>     4b.1) is there a way to "revert" the source LV to the snapshot?
>     	(without allocating snapshot as big as source LV)

Why do you resize the LV if you want to test it first? Give the
snapshot the extra 500G and resize that. If it fails you just remove
the snapshot and try again.

If it succeeds then you can do it the other way around and resize for
real.

MfG
        Goswin
