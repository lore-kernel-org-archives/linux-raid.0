From: Brendan Conoboy <blc@redhat.com>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Thu, 28 Feb 2008 14:04:52 -0700
Message-ID: <47C721F4.1080506@redhat.com>
References: <1204195554.16924.16.camel@franck-gusty>	<20080228192500.4d9110d9@absurd> <20080228215339.6674f29d@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080228215339.6674f29d@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> * two 6 disks raid10 arrays : theoretical max speed 6 times single disc
> * three 4 disks raid10 arrays : theoretical max speed 4 times single disc
> * single raid10 far=2  : theoretical max speed 12 times single disc (!)
> 
> isn't that true?

If speed is raw throughput then that's approximately right.  Unless 
you're streaming huge piles of data, that sort of speed isn't what you 
need to tune for, though.  Look at it this way:

two 6 disk raid 10 arrays : theoretical max seeks per operation: 6 times 
the seeks of a single disk

three 4 disk raid 10 arrays: theoretical max seeks per operation: 4 
times the seeks of a single disk

one 12 disk raid 10 arrays: theoretical max seeks per operation: 12 
times the seeks of a single disk!

Seeks are bad.  You have to tune for your workload.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
