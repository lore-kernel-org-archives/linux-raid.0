From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: raid5 - failed disks - i'm confusing
Date: Tue, 05 Apr 2005 07:46:04 +1200
Message-ID: <4251997C.30001@sauce.co.nz>
References: <Pine.LNX.3.96.1050401031922.31230A-100000@Maggie.Linux-Consulting.com> <1112641157.29559.22.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1112641157.29559.22.camel@compaq-rhel4.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:

> Anyway, it might or might not hurt the drives to run them well below
> their designed operating temperature, I don't have schematics and
> materials lists in front of me to tell for sure.  But second guessing
> mechanical engineers that likely have compensated for thermal issues at
> a given, specific common operating temperature is usually risky.  Most
> people think "Heat kills" and therefore like to keep things as cool as
> possible.  For mechanical devices anyway, it's not so much that heat
> kills, as it is operating outside of the designed temperature range,
> either above or below, that reduces overall life expectancy.  Keep your
> drives from overheating, but don't try to freeze them would be my
> advice.

Indeed. This paper

  http://www.hitachigst.com/hdd/technolo/drivetemp/drivetemp.htm

shows some of the factors you mention and for what it's worth Hitachi's
recommended operating range is 5 - 55 C for their 15K SCSI.

Regards,

Richard

