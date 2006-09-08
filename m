From: "David Rees" <drees76@gmail.com>
Subject: Re: Messed up creating new array...
Date: Fri, 8 Sep 2006 13:40:25 -0700
Message-ID: <72dbd3150609081340p2c35ccacs5f2e0b3d33c73eb9@mail.gmail.com>
References: <001201c6d34f$b0651710$0e00a8c0@sherlock>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001201c6d34f$b0651710$0e00a8c0@sherlock>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/8/06, Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org> wrote:
> I messed up slightly when creating a new 6-disk raid6 array, and am wondering
> if there is a simple answer. The problem is that I didn't partition the drives,
> but simply used the whole drive. All drives are of the same type and using the
> Supermicro SAT2-MV8 controller.

This should work:

1. Unmount filesystem.
2. Shrink file system to something a bit smaller. Since it's a big
array, 1GB should give you plenty of room.
3. Shrink raid array to something in between the new fs size and old
fs size. Make sure you don't shrink it smaller than the filesystem!
4. Remove a disk from the array (fail/remove)
5. Partition disk
6. Add partition back to array
7. Repeat steps 4-6 for all disks in the array.
8. Now the whole array should be on partitions. Grow the raid array
back to "max".
9. Grow filesystem to the partition size.

-Dave
