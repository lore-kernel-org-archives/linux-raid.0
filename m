From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-10 unbalanced reads
Date: Tue, 24 Feb 2009 00:37:52 +0100
Message-ID: <20090223233752.GA3458@lazy.lzy>
References: <20090209202728.GA11996@lazy.lzy> <20090209231138.GB13450@rap.rap.dk> <20090223221532.GA23542@lazy.lzy> <20090223225202.GA28505@rap.rap.dk> <20090223232415.GA24493@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090223232415.GA24493@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

one more thing I see right now:

mdadm --examine-bitmap for sd[ab]2

mdadm --examine-bitmap /dev/sda2
        Filename : /dev/sda2
           Magic : 6d746962
         Version : 4
            UUID : 54db81a7:b47e9253:7291055e:4953c163
          Events : 2772
  Events Cleared : 2772
           State : OK
       Chunksize : 512 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 312464000 (297.99 GiB 319.96 GB)
          Bitmap : 610282 bits (chunks), 0 dirty (0.0%)

mdadm --examine-bitmap /dev/sdb2
        Filename : /dev/sdb2
           Magic : 6d746962
         Version : 4
            UUID : 54db81a7:b47e9253:7291055e:4953c163
          Events : 2772
  Events Cleared : 2772
           State : OK
       Chunksize : 512 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 312464000 (297.99 GiB 319.96 GB)
          Bitmap : 610282 bits (chunks), 22506 dirty (3.7%)

Is it the last line a bit strange?
And this is somehow persistent, i.e. after consecutive
"examinations" the dirty status of sdb2 does not
change, while sda2 goes a little bit up and down.

This, BTW, is after a reboot, so a "clean" machine,
and without "smartd".

bye,

-- 

piergiorgio
