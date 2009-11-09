From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID 6 Failure follow up
Date: Mon, 09 Nov 2009 15:57:29 +1300
Message-ID: <4AF78519.6020502@sauce.co.nz>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com>	 <4AF6D5FD.2010602@gmail.com> <4AF70791.9080007@sauce.co.nz>	 <4AF741A9.80701@gmail.com> <4AF74D39.3000304@sauce.co.nz> <7d86ddb90911081845j675818a2vec1a5bd26d542024@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90911081845j675818a2vec1a5bd26d542024@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: Andrew Dunn <andrew.g.dunn@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ryan Wagoner wrote:
> This is interesting to hear as I have been using smartmontools on my
> Supermicro LSI 1068E controller with the target firmware for 2 years
> now on CentOS 5. I have 3 RAID 1 arrays across 2 drives, a RAID 5
> drive across 3 drives, and a RAID 0 across 2 drives.

I have 3 boxes using 1068E controllers attached to 16 drive port 
expander based chassis that have been built over the last 2.5 years and 
they all react badly.

In fact the latest one put together a month ago (which is using more 
recent controller IT firmware and kernel than the other two), will not 
tolerate a single smartctl command, where the other two will maybe 50% 
of the time.

Something is not right here and others running different drive setups - 
direct attached and port multipler based are seeing the same thing.

Suffice it to say, I would recommend heavy testing before putting into 
production and I personally have no confidence currently.

Regards,

Richard
