From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: [linux-lvm] Q: Online resizing ext3 FS
Date: Thu, 13 Sep 2007 14:59:39 +0200
Message-ID: <87ejh2n2kk.fsf@informatik.uni-tuebingen.de>
References: <20070912163621.1f951876@slopi> <46E7FE32.7010404@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46E7FE32.7010404@wpkg.org> (Tomasz Chmielewski's message of
	"Wed, 12 Sep 2007 16:56:50 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Chmielewski <mangoo@wpkg.org> writes:

> Chris Osicki schrieb:
>> Hi
>>
>> I apologize in advance for asking a question not really appropriate
>> for this mailing list, but I couldn't find a better place with lots of
>> people managing lots of disk space.
>>
>> The question:
>> Has anyone of you been using ext2online to resize (large) ext3 filesystems?
>> I have to do it going from 500GB to 1TB on a productive system I was
>> wondering if you have some horror/success stories.
>> I'm using RHEL4/U4 (kernel 2.6.9) on this system.

That kernel seems to be a bit old. Better upgrade first.

I did some resizes in that size range. Although just adding 50-200GB
not doubling the size in one go. But I see no reason it should
fail. Growing the fs was always quick (a minute or two) and
painless. Maybe because I have used -Tlargefile4 for mke2fs so the
amount of inodes is drastically reduced.

> Yes, I tried to online resize a similar filesystem (600 MB to 1.2 TB)
> and it didn't work.
>
> At some point, resize2fs would just exit with errors.
> I tried to do it several times before I figured out what's missing;
> sometimes, I interrupted the process with ctrl+c. No data loss
> occurred.
>
> To do an online ext3 resize, the filesystem needs a "resize_inode"
> feature. You can check the features with dumpe2fs:

So was that what you were missing or did some other error occur?

I tried to resize an fs without resize_inode and it just plain told me
and abrted.

MfG
        Goswin
