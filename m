From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Linux MD? Or an H710p?
Date: Thu, 24 Oct 2013 01:23:18 -0500
Message-ID: <5268BCD6.4000305@hardwarefreak.com>
References: <526328AE.2020908@gmail.com> <21093.14265.261728.755087@quad.stoffel.home> <5265C89A.4000908@gmail.com> <52662849.1080003@hesbynett.no> <5266AE51.4050501@hardwarefreak.com> <526774B4.400@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526774B4.400@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Steve Bergman <sbergman27@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/23/2013 2:03 AM, David Brown wrote:

> On the other hand, he is also serving 100+ freenx desktop users.  As far
> as I understand it (and I'm very happy for corrections if I'm wrong),
> that will mean a /home directory with 100+ sub-directories for the
> different users - and that /is/ one of the ideal cases for concat+XFS
> parallelism.

No, it is /not/.  Homedir storage is not an ideal use case.  It's not
even in the ballpark.  There's simply not enough parallelism nor IOPS
involved, and file sizes can vary substantially, so the workload is not
deterministic, i.e. it is "general".  Recall I said in my last reply
that this "is a very workload specific storage architecture"?

Workloads that benefit from XFS over concatenated disks are those that:

1.  Expose inherent limitations and/or inefficiencies of striping,
    at the filesystem, elevator, and/or hardware level

2.  Exhibit a high degree of directory level parallelism

3.  Exhibit high IOPS or data rates

4.  Most importantly, exhibit relatively deterministic IO patterns

Typical homedir storage meets none of these criteria.  Homedir files on
a GUI desktop terminal server are not 'typical', but the TS workload
doesn't meet these criteria either.

-- 
Stan

