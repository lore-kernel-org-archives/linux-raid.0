From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Faster read performance DURING (?) resync on raid10
Date: Fri, 26 Sep 2008 09:03:44 +0100
Message-ID: <48DC9760.90905@anonymous.org.uk>
References: <19666016.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19666016.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 25/09/2008 10:27, sminded wrote:
> The strange thing is that I can see a significant increase in read
> performance (about 20%) when running the tests DURING the raid resync phase
> directly after the raid creation

Is it possible this is because the resync process has already read part 
of the disc into cache when your test starts, effectively poisioning the 
test results?

Cheers,

John.
