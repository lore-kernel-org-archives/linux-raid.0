From: Dirk Hufnagel <hufnagel@mps.ohio-state.edu>
Subject: Re: XFS RAID only writing half the time
Date: Tue, 25 Nov 2003 14:26:49 -0500
Sender: linux-xfs-bounce@oss.sgi.com
Message-ID: <3FC3ACF9.4000509@mps.ohio-state.edu>
References: <114.2c0b3fa3.2cf4ee43@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-xfs-bounce@oss.sgi.com>
In-Reply-To: <114.2c0b3fa3.2cf4ee43@aol.com>
Errors-to: linux-xfs-bounce@oss.sgi.com
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

AndyLiebman@aol.com wrote:
> Hendrik, 

<snip>

> I'm going to want to try to come up with some settings that allow capturing 
> uncompressed video (18 MB/sec) while one or two other users are trying to read 
> DV video (3.5 MB/sec) from the same drives. I guess that means I will want get 
> the cache written to disk as soon as possible (leaving margin for difficult 
> moments) while allowing other users to read from the disk on demand. In some 
> ways, reading video files is more demanding than writing -- because what is read 
> MUST arrive at the client computer exactly when needed. 

Could be problematic since you can't just add bandwidth requierements
and compare it to the maximum bandwidth. Multiple active disk access
jobs means that the disk will be seeking, which means that the read
accesses will interfere with your write stream, possible to a point
where the writing will skip.

If you are not writing 24/7 and it's in your budget, I would put two
RAID arrays into the machine, one to write to and the other one
for reading. You can synchronize them whenever you are not writing.
Of course, that only works if you don't need to read the written
data immediatly. For the read array I would use Raid5 for the data
security and for the write array you can either use Raid5 or Raid0.
Raid0 is faster compared to Raid5, especially for writes, but it
would mean your data isn't secure until it has been copied to the
other Raid5 array.

	Dirk
