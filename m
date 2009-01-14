From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Reshape speed
Date: Tue, 13 Jan 2009 18:52:37 -0600
Message-ID: <496D3755.7020905@gmail.com>
References: <C592DCCC.C013%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C592DCCC.C013%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Iain Rauch wrote:
> Hi,
> 
> I've recently assembled a new RAID 6.
> 
> When I assembled it, I had 3 disks and one missing.
> 
> I then added two disks.
> 
> The first disk was used to recover the originally missing disk.
> 
> The second disk is being used to grow the array.
> 
> The recovery went at about 45MB/s but the reshape is only around 11MB/s.
> 
> CPU usage is as follows:
>  12.8   1398    root     [md1_raid5]
>  2.0    7996    root     [md1_reshape]
> 
> Memory usage is as follows:
> Type                    Percent Capacity    Free        Used        Size
> Physical Memory         18%                 2.97 GB     661.03 MB   3.62 GB
> - Kernel + applications 6%                              218.21 MB
> - Buffers               0%                              7.67 MB
> - Cached                12%                             435.14 MB
> Disk Swap               0%                  0.00 KB     0.00 KB     0.00 KB
> Disk Swap               0%                  0.00 KB     0.00 KB     0.00 KB
> 
> #uname -a
> Linux edna 2.6.24-etchnhalf.1-amd64 #1 SMP Tue Dec 2 17:21:26 UTC 2008
> x86_64 GNU/Linux
> 
> Why is the reshape so much slower? Where's the bottleneck?

Reshapes are expensive.

Rebuilds only have to read the other n disks and calculate parity and 
put it on the replaced disk.

Reshapes have to move data around to make a n+1 disk array from a n 
disk array, which means *lots* of reading and writing on all of the 
other n disks to make it look like it was originally built as a n+1 
disk array.     It is very likely that it will have to read every bit 
of the data, calculate parity and then rewrite it back into the 
correct new location for the entire array, so that adds an entire new 
write step for all of the disks, and on top of that adds a seek from 
the read location to the new write location onto the disk too.
