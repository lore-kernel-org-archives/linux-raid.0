From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID 6 Failure follow up
Date: Mon, 09 Nov 2009 11:59:05 +1300
Message-ID: <4AF74D39.3000304@sauce.co.nz>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com> <4AF6D5FD.2010602@gmail.com> <4AF70791.9080007@sauce.co.nz> <4AF741A9.80701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF741A9.80701@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andrew Dunn wrote:
> I am not, but this is quite interesting. What versions are affected? I
> am in ubuntu 9.10.

To my knowledge, there is no smartmontools version safe for use on these 
LSI based controllers.

You may run smartctl commands a few times and get away with it, but 
eventually it will bite you.

Losing 14 drives on a 16 drive array as a result, is no fun...

Hopefully it will be fixed one day.

Regards,

Richard
