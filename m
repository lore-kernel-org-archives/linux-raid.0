From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RFC swap over raid1
Date: Fri, 2 Aug 2013 11:21:09 -0300
Message-ID: <CAH3kUhE2ys1nGetLy0p=9rj2BxajAvBdWACFXHMe4TP81zNh=w@mail.gmail.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com>
	<51FAE985.1040809@redhat.com>
	<CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com>
	<51FB63C8.2090300@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51FB63C8.2090300@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Doug Ledford <dledford@redhat.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hummm, wow very new informations to me...

today linux don't have a generic badblock remap?! that's what i understood?
for example... ext2,3,4,xfs,reiserfs,zfs, and others fs, they handle
badblock by their self? right?

it's a nice information i never thinked about a layer only for
badblock reallocation, i read/write in this list of linux-raid when
the started the badblock development, in some time near to raid1 write
multithread

today the badblock of raid1 is embedded in the source? or it's easy to
implement a new layer just to badblock realloc logic?

about "mkswap -c" it just show information like you told, i'm a bit
surprised about no badblock at swap that's information is new to me i
will read about others os (freebsd, reactos, etc) to check how they
handle this there

I'm rethinking now about the swap as a file in a filesystem, this
could increase security or another solution is better?
