From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [linux-lvm] Q: Online resizing ext3 FS
Date: Thu, 13 Sep 2007 15:07:52 +0200
Message-ID: <46E93628.3060902@wpkg.org>
References: <20070912163621.1f951876@slopi> <46E7FE32.7010404@wpkg.org> <87ejh2n2kk.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ejh2n2kk.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow schrieb:
> Tomasz Chmielewski <mangoo@wpkg.org> writes:

(...)

>> Yes, I tried to online resize a similar filesystem (600 MB to 1.2 TB)
>> and it didn't work.
>>
>> At some point, resize2fs would just exit with errors.
>> I tried to do it several times before I figured out what's missing;
>> sometimes, I interrupted the process with ctrl+c. No data loss
>> occurred.
>>
>> To do an online ext3 resize, the filesystem needs a "resize_inode"
>> feature. You can check the features with dumpe2fs:
> 
> So was that what you were missing or did some other error occur?
> 
> I tried to resize an fs without resize_inode and it just plain told me
> and abrted.

It was working for some time (15 or 30 minutes?), the fs grew a couple 
of gigabytes, and then it exited with an error. At first I thought it's 
because the fs might need fsck, but after I did fsck, it didn't help - 
next online tries didn't increase the fs anymore.


-- 
Tomasz Chmielewski
http://wpkg.org
