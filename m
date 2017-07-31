From: Dima Dvorcovoy <dvorc@bsu.by>
Subject: remove mdadm stripe limitation, pls
Date: Mon, 31 Jul 2017 18:52:24 +0300
Message-ID: <1501516344.23767.4.camel@bsu.by>
References: <S1752524AbdGaPpr/20170731154547Z+299@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S1752524AbdGaPpr/20170731154547Z+299@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I got in trouble trying to mount RAID0 drives from brocen HW
controller. The mdadm utility is locked to 4k stripe minimum, but these
drives have 1s (512bytes) stripes. 

Then, I dig into kernel and found there are no actual stripe limitation
seems. So, all the limits are in mdadm code. I patched soure and all
works ok. 
mdadm --build /dev/md0 --level=0 --chunk=1s --raid-devices=2 /dev/sdd
/dev/sdc 

First: there are UNDOCUCMENTED option in --chunk, size could be given
in sectors (s). 

Second: 1s used as INVALID_SECTORS constant. I changed it to 0xffff 

Third: The sector number is stored in K. I removes this division, maybe
it is only for output. 

Where to connect with mdadm team to ask for changes? What I skipped to
patch? 

[mdadm.h] 
1737c1737 
< * a value for 'invalid'. Use '1'. 
--- 
> * a value for 'invalid'. Use '-1'. 
1739c1739 
< #define INVALID_SECTORS 1 
--- 
> #define INVALID_SECTORS 0xffff 
[mdadm.c] 
381,384c381,382 
< if (s.chunk == INVALID_SECTORS || 
< s.chunk < 8 || (s.chunk&1)) { 
< pr_err("invalid chunk/rounding value: %s\n", 
< optarg); 
--- 
> if (s.chunk == INVALID_SECTORS) { 
> pr_err("invalid chunk/rounding value: %s\n",optarg); 
[Build.c] 
387,388d384 
< /* Convert sectors to K */ 
< s.chunk /= 2; 
145c145 
< array.chunk_size = s->chunk*1024; 
--- 
> array.chunk_size = s->chunk*512; 
[Create.c] 
696c696 
< info.array.chunk_size = s->chunk*1024; 
--- 
> info.array.chunk_size = s->chunk*512;
