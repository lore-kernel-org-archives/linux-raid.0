From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Samsung F1 RAID Class SATA/300 1TB drives
Date: Thu, 04 Nov 2010 11:30:48 +0000
Message-ID: <4CD29968.9010305@anonymous.org.uk>
References: <61.E7.19545.3D73FCC4@cdptpa-omtalb.mail.rr.com> <4CD19603.4060308@tmr.com> <4CD21261.8090701@anonymous.org.uk> <4CD28C2F.8010104@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD28C2F.8010104@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: Bill Davidsen <davidsen@tmr.com>, 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/2010 10:34, Tim Small wrote:
> On 04/11/10 01:54, John Robinson wrote:
>> operating power is 7W, the maximum transition power (whatever that is)
>> is 40W - yes, 40W
>
> I'd guess this is either during spin-up, (or spin speed change if
> enabled), or possibly even the "inrush" current when power is first
> applied to the device (i.e. only for a few milliseconds when the machine
> is turned on), and so probably wouldn't cause much of a problem unless.

Yes, reading the spec more closely indicates that this transition power 
is the drive waking up from its lowest power-saving mode, so it's 
spinning up the discs, so that's not going to be happening much.

In second place after spin-up events, from the same spec, we have peak 
power during random reads of 24W, and 26W for writes, still more than 3 
times the average operating power. I take "random reads" to mean lots of 
seeks, so as Bill said, heavy seeking could be rather rough on a PSU.

Cheers,

John.
