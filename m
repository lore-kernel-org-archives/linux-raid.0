From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Chunk size change stop/restart
Date: Tue, 17 Dec 2013 20:00:19 +0100
Message-ID: <20131217190019.GA1883@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I started the process of changing the chunk
size of a RAID-5 array (5 HDDs).

Unfortunately, I unwisely choose a quite slow
device for the backup file.

Is it possible, without stopping the array, to
stop the "reshape", move the backup file to a
faster place and restart the process?

Thanks,

bye,

-- 

piergiorgio
