From: Vasco =?iso-8859-15?b?Tul2b2E=?= <vasco.nevoa@sapo.pt>
Subject: Re: how to recover filesystem after clobbering array?
Date: Tue, 19 Jul 2011 12:01:53 +0100
Message-ID: <20110719120153.1529669k4o1t6v4x@mail.sapo.pt>
References: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt>
	<j03lp4$h72$1@dough.gmane.org> <4E255FE1.2060006@tolaris.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E255FE1.2060006@tolaris.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you very much, Tyler and David.
Good advice.

The array is level 1, built upon primary partitions of the devices.
The file system is EXT4.
The mdadm command that I stupidly used to create instead of starting  
the array included "--assume-clean" but no "--build".
I checked via /proc/mdadm that the array came up without syncing  
anything (or at least it was ultra-fast, less than 5 seconds).
So I firmly believe the data is all there, on both disks.
I just need to rebuild the metadata to point to the data again somehow.
Right?...

Citando "Tyler J. Wagner" <tyler@tolaris.com>:

> On 2011-07-19 11:17, David Brown wrote:
>> Once you have got image files for each of your disks, make copies of
>> these image files to another spare disk. Keep careful notes of exactly
>> what you have done here, and which files are which. And put your
>> original disks, carefully labelled, on a shelf somewhere.
>>
>> Now you are in a position to attempt data recovery on your copied
>> files. If you do something wrong, you can simply re-copy the image
>> files and try again. You still have absolutely no guarantees that
>> you'll get anything back - but at least you can be sure you are not
>> going to make anything worse.
>
> Follow David's advice.
>
> What was the filesystem on the array?
>
> Now, use testdisk, photorec, and foremost to seek through the raw images
> and extract files. The good news is, most video formats are detectable
> by these tools. All can be installed with your package manager.
>
> Regards,
> Tyler
>
> --
> "Offending fundamentalists isn't my goal - but if it is an inevitable
> side-effect of defending human rights, so be it."
>    -- Johann Hari
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


