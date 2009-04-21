From: Michal Soltys <soltys@ziu.info>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Tue, 21 Apr 2009 10:57:49 +0200
Message-ID: <49ED8A8D.3050800@ziu.info>
References: <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090420212444.GA5193@lazy.lzy> <A52FE0A1-DC54-4786-9FE0-C0251C78C9FD@redhat.com> <B982A8CB-4054-4F17-B269-A737462B2A81@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B982A8CB-4054-4F17-B269-A737462B2A81@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> On Apr 20, 2009, at 7:47 PM, Doug Ledford wrote:
> 
> Actually, I want to expand on this thought for a little bit.  I'm 
> obviously harping on all the symlinks and stuff that mdadm creates when 
> you tell it what you want it to do.  I know these were added for back 
> compatibility reasons.  However, the problem I have is that I work on 
> mdadm for a living (well, sorta, I have 30+ other packages I also 
> maintain, many of them orders of magnitude larger than mdadm, and I do 
> kernel work, so my mdadm specific time is fairly small, but still it's 
> paid time), and I've sat down before and tried to figure out "if I use 
> name 'X' for my array, what device file gets created".  The net result 
> of my attempts to do that, were that I was never able to figure out just 
> by running mdadm what the proper syntax for the name variable is/was.  

Mdadm will create the name you want it to. If it makes sense from 
kernel's perspective (aka, it's mdN or md_dN) it will be the same as you 
can see under /sys - assuming it's not taken already . If not, or if 
it's taken - you will have name defined in mdadm.conf under /dev or 
/dev/md/, but from /sys perspective it will be something like md127 or 
md_d127. If you create under /dev/md/ directory, mdadm will symlink from 
/dev or not - depending on CREATE line in mdadm.conf or appropriate 
commandline option.

At the same time udev will do its own stuff. It doesn't care about names 
   defined in mdadm.conf or specified on commandline. The stock udev 
rules will create /sys -like names in /dev - including leftovers of 
inactive arrays and produce all the symlinks it's told to - some from 
/dev/disk/by* , some from /dev/md (which might conflict with default 
mdadm's behaviour if one does mdadm -Es >>/etc/mdadm.conf and doesn't 
even bother adjusting it).

By default, mdadm -Es will create devies using /dev/md/ directory with 
stripped md[_] prefix (if the name is standard). In case of 1.x 
superblocks, the name stored in it will be used (by default - name set 
during --create w/o any md prefix).

In practice I've never used homehost, besides few tests for the sake of 
this thread. The behaviour seemed consistent with the above though.

The above is under assumption of versions 2.9.x . I haven't used 3.x 
branch yet.
