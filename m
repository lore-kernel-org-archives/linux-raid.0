From: David Brown <david.brown@hesbynett.no>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Wed, 12 Sep 2012 09:58:12 +0200
Message-ID: <50504094.2040302@hesbynett.no>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent <hanguozhong@meganovo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/09/2012 09:04, vincent wrote:
> Hi, everyone:
>          I am Vincent, I am writing to you to ask a question about how to
> make file system about my raid5.
>          I created a raid5 with 16 *2T disks, it was OK.
>          Then I used mk2fs to make file system for the raid5.
>          Unfortunately, it was failed.
>          The output was:
>          # mke2fs -t ext4 /dev/md126
>            mke2fs 1.41.12 (17-May-2010)
>            mke2fs: Size of device /dev/md126 too big to be expressed in 32
> bits
>            using a blocksize of 4096.
>          Is anyone had the same problem? Could you help me?
>          The version of my mdadm is 3.2.2, and the version of my kernel is
> 2.6.38
>          Thanks.
>

You need e2fsprogs version 1.42 or above to create an ext4 filesystem 
larger than 16 TB.

However, it is more common to use XFS for such large filesystems.

Another possibility is putting an LVM physical volume on the array and 
making multiple smaller logical partitions for your filesystem.

Almost certainly, however, a raid5 of 16 disks is a bad idea. 
Performance for writes will be terrible, as will parallel reads and 
writes (though that will improve dramatically as the current 
developments in multi-threaded raid5 make their way into mainstream 
distros).  And it is very poor from a reliability viewpoint - your risk 
of a second failure during a rebuild is high with a 16 disk raid5.

What is your actual application here?  If you tell us how this system 
will be used, it will be a lot easier to advise you on a better solution 
(perhaps a raid6, perhaps a raid10, perhaps a number of raid5 systems 
connected with raid0, perhaps multiple raid0 or raid5 arrays with a 
linear concatenation and XFS).

