From: "rae l" <crquan@gmail.com>
Subject: Re: from raid456 patch, about the tiotest tool
Date: Wed, 3 Sep 2008 18:21:02 +0800
Message-ID: <91b13c310809030321t143579b9l2364cfac6608da43@mail.gmail.com>
References: <91b13c310808261103y326d57e8q737647b88d925daa@mail.gmail.com>
	 <91b13c310809020102j42e91ba2q65dd2f2f60bfde35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <91b13c310809020102j42e91ba2q65dd2f2f60bfde35@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, jmm@users.sourceforge.net, mhydra@users.sourceforge.net, miku@users.sourceforge.net
Cc: linux-raid@vger.kernel.org, "James W. Laferriere" <babydr@baby-dragons.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 2, 2008 at 4:02 PM, rae l <crquan@gmail.com> wrote:
> On Wed, Aug 27, 2008 at 2:03 AM, rae l <crquan@gmail.com> wrote:
>> Hello, Dan:
>>  I've known your md(raid456) patch just before v2.6.26,
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8b3e6cdc53b7f29f7026955d6cb6902a49322a15
>>
>> your md patch referred to tiobench, which is the multi-thread
>> benchmark tool, I'm interested on this tool and I found I ran it
>> differently with your results, so I want to know more about it,
>>
>> from its home page, it only released v0.3.3 on Mar 2002,
>>
>> http://sourceforge.net/projects/tiobench/
>>
>> but from its cvs repository, it has released v0.4.1,
>>
>> http://tiobench.cvs.sourceforge.net/tiobench/tiobench/
>>
>> Could you tell me what version of tiobench did you use? I want to see
>> if that's my configuration fault or I have used wrong program version.
>>
>> And when using v0.4.1 of tiobench from its cvs repository, I found its
>> multiple threads random IO statistics code reported wrong results, and
>> have resolved it by this patch,
>>
>> http://sourceforge.net/tracker/index.php?func=detail&aid=2047536&group_id=3857&atid=303857
>>
>> But its upstream seems have not noticed it yet, so I want to if
>> someone on this mailling-list know tiobench upstream and be able to
>> take this message?
>
> Hope someone can wake up the tiobench developer?
>

Regretfully, the tiotest v0.4.1 still have bugs that I haven't
resolved, even applied my previous patch,

such as this reported on a single SATA disk, simple dd benchmark
report its bandwidth is 70MB/s, do you believe it has 1489.8 MB/s
random read performance?

But it's weird when I'm using systemtap on it,

# stap -ve 'probe kernel.function("vfs_read@fs/read_write.c") { ... }'

it reports all pread successfully return fast,

# ./tiotest -R -d /dev/sdb5 -f 1 -r 1024000 -t 1
Tiotest results for 1 concurrent io threads:
,----------------------------------------------------------------------.
| Item                  | Time     | Rate         | Usr CPU  | Sys CPU |
+-----------------------+----------+--------------+----------+---------+
| Write           1 MBs |    0.1 s |   8.814 MB/s |   0.0 %  |   8.8 % |
| Random Write 4000 MBs |    5.1 s | 785.431 MB/s |  11.2 %  |  86.8 % |
| Read            1 MBs |    0.0 s | 1037.344 MB/s |   0.0 %  |   0.0 % |
| Random Read  4000 MBs |    2.7 s | 1489.866 MB/s |  27.6 %  |  72.2 % |
`----------------------------------------------------------------------'
Tiotest latency results:
,-------------------------------------------------------------------------.
| Item         | Average latency | Maximum latency | % >2 sec | % >10 sec |
+--------------+-----------------+-----------------+----------+-----------+
| Write        |        0.007 ms |        0.028 ms |  0.00000 |   0.00000 |
| Random Write |        0.004 ms |        0.229 ms |  0.00000 |   0.00000 |
| Read         |        0.003 ms |        0.058 ms |  0.00000 |   0.00000 |
| Random Read  |        0.002 ms |        0.222 ms |  0.00000 |   0.00000 |
|--------------+-----------------+-----------------+----------+-----------|
| Total        |        0.003 ms |        0.229 ms |  0.00000 |   0.00000 |
`--------------+-----------------+-----------------+----------+-----------'



-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
