From: Phil Turmel <philip@turmel.org>
Subject: Re: Requesting assistance recovering RAID-5 array
Date: Mon, 30 Mar 2020 21:50:30 -0400
Message-ID: <92b8501b-af27-b6dc-b35b-fd3142386ade@turmel.org>
References: <CAB00BMjPSg2wdq7pjt=AwmcDmr0ep2+Xr0EAy6CNnVhOsWk8pg@mail.gmail.com>
 <058b3f48-e69d-2783-8e08-693ad27693f6@youngman.org.uk>
 <CAB00BMgYmi+4XvdmJDWjQ8qGWa9m0mqj7yvrK3QSNH9SzYjypw@mail.gmail.com>
 <etPan.5e829cbd.69391496.da7e@crowston.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <etPan.5e829cbd.69391496.da7e@crowston.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "crowston.name" <kevin@crowston.name>, Daniel Jones <dj@iowni.com>, antlists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Kevin,

On 3/30/20 9:27 PM, crowston.name wrote:
> I got the following error trying to run lsdrv:
> 
> ./lsdrv
> Traceback (most recent call last):
>    File "./lsdrv", line 423, in <module>
>      probe_block('/sys/block/'+x)
>    File "./lsdrv", line 340, in probe_block
>      blk.__dict__.update(extractvars(runx(['vol_id', '--export', '/dev/block/'+blk.dev])))
>    File "./lsdrv", line 125, in runx
>      out, err = sub.communicate()
>    File "/usr/lib/python2.5/subprocess.py", line 667, in communicate
>      return self._communicate(input)
>    File "/usr/lib/python2.5/subprocess.py", line 1138, in _communicate
>      rlist, wlist, xlist = select.select(read_set, write_set, [])
> select.error: (4, 'Interrupted system call')
> 
> 
> 
> 
> Kevin Crowston
> 206 Meadowbrook Dr.
> Syracuse, NY 13210 USA
> Phone: +1 (315) 464-0272
> Fax: +1 (815) 550-2155

Please don't hijack threads with unrelated reports.

Please report this on github where I can track it, but note that I'm not 
even trying to support python 2.5.

Phil
