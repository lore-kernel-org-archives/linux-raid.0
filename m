From: Pol Hallen <raid2@fuckaround.org>
Subject: Re: Unstable speed or correct?
Date: Thu, 9 Jun 2011 11:02:32 +0200
Message-ID: <201106091102.32709.raid2@fuckaround.org>
References: <201106090909.23757.raid2@fuckaround.org> <BANLkTimbhe+qmTyVWKbRt6TZ9cynmmVNRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimbhe+qmTyVWKbRt6TZ9cynmmVNRw@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Durval Menezes <durval.menezes@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> What benchmark program did you use for the test? Also, was there any other
> programs running at the same time? Was the machine in single-user (init 1)
> state?

hello :-)

dd if=/dev/zero of=/share/raid6/1Gb bs=1024 count=1000000
1000000+0 records in
1000000+0 records out
1024000000 bytes (1.0 GB) copied, 12.1632 s, 84.2 MB/s

dd if=/dev/zero of=/share/raid6/10Gb bs=1024 count=10000000
10000000+0 records in
10000000+0 records out
10240000000 bytes (10 GB) copied, 142.021 s, 72.1 MB/s

That graphic with palimptest (gnome-disk-utility).

No other applications uses raid (I'm on init 2 but samba, ftp, and other 
daemons are off)

iostat not show me any activity by raid, so I think there is not programs that 
runs on array.

thanks :-) 

Pol
