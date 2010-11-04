From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Samsung F1 RAID Class SATA/300 1TB drives
Date: Thu, 04 Nov 2010 01:54:41 +0000
Message-ID: <4CD21261.8090701@anonymous.org.uk>
References: <61.E7.19545.3D73FCC4@cdptpa-omtalb.mail.rr.com> <4CD19603.4060308@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD19603.4060308@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/11/2010 17:04, Bill Davidsen wrote:
> Leslie Rhorer wrote:
[...]
>>  I'm not entirely sure when the drives all went bad, but it was
>> within a week or two of each other.
>
> One possible cause for this is a marginal power supply which "can't keep
> up" when supporting lots of seeks and transfers on multiple drives. In
> every group of drives there will be some variance for low voltage (or
> noise, more likely) and the drive(s) which are sensitive appear to fail.
> I say this from experience, it does happen, and going to a better power
> supply will cure it. This might not be the problem, of course, but it's
> worth investigating before blaming the drives.

Yes, marginal PSUs can be, well, marginal, but it seems even half decent 
PSUs can exhibit this behaviour as well, to some extent. So having read 
the above I thought I'd look up some data sheets to see why this might 
happen.

The spec for Seagate Constellation ES 1GB drives - 
http://www.seagate.com/staticfiles/support/disc/manuals/enterprise/Constellation%203_5%20in/100516232f.pdf 
- does say that while the average idle power is 5W[1], and the typical 
peak operating power is 7W, the maximum transition power (whatever that 
is) is 40W - yes, 40W - so I can well see a bundle of relatively 
low-power drives placing some heavy stresses on an average or even 
average-to-good PSU.

My rule of thumb of late is to expect 7.2k drives to draw ~7W, 10k ~10W 
and 15k ~15W, then add a margin for safety and power-up, but having read 
the above noted I might double it and make the margin bigger...

Cheers,

John.
[1] Rounded up to the nearest W.
