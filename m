From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: sequential versus random I/O
Date: Wed, 29 Jan 2014 20:38:51 -0600
Message-ID: <52E9BB3B.7010600@hardwarefreak.com>
References: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/29/2014 11:23 AM, Matt Garman wrote:
...
> In particular, we have a big NFS server that houses a collection of
> large files (average ~400 MB).  The server is read-only mounted by
> dozens of compute nodes.  Each compute node in turn runs dozens of
> processes that continually re-read those big files.  Generally
> speaking, should the NFS server (including RAID subsystem) be tuned
> for sequential I/O or random I/O?
...


If your workflow description is accurate, and assuming you're trying to
fix a bottleneck at the NFS server, the solution to this is simple, and
very well known:  local scratch space.  Given your workflow description
it's odd that you're not already doing so.  Which leads me to believe
that the description isn't entirely accurate.  If it is, you simply copy
each file to local scratch disk and iterate over it locally.  If you're
using diskless compute nodes then that's an architectural
flaw/oversight, as this workload as described begs for scratch disk.

-- 
Stan
