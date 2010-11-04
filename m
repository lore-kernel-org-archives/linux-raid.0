From: Tim Small <tim@seoss.co.uk>
Subject: Re: Samsung F1 RAID Class SATA/300 1TB drives
Date: Thu, 04 Nov 2010 10:34:23 +0000
Message-ID: <4CD28C2F.8010104@seoss.co.uk>
References: <61.E7.19545.3D73FCC4@cdptpa-omtalb.mail.rr.com> <4CD19603.4060308@tmr.com> <4CD21261.8090701@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD21261.8090701@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Bill Davidsen <davidsen@tmr.com>, 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/10 01:54, John Robinson wrote:
> operating power is 7W, the maximum transition power (whatever that is) 
> is 40W - yes, 40W

I'd guess this is either during spin-up, (or spin speed change if 
enabled), or possibly even the "inrush" current when power is first 
applied to the device (i.e. only for a few milliseconds when the machine 
is turned on), and so probably wouldn't cause much of a problem unless.

To check for such transient power supply issues, you need a good fast 
(expensive) digital scope, I'd guess - so that you can catch very 
short-lived ("transient") spikes or sags in the supply voltages, but you 
can do some quite easy checks to see if any of the speced currents are 
being exceeded (or are near the specified limits) over longer periods 
using a "DC Current Clamp" - such as a "UT203" clamp which I bought on 
ebay for about US$30.

A quick search showed that there are other models available at about 
double the price which have an "inrush" function which presumably 
measures the peak transient current  e.g. "Mastech MS2108" - so this 
might be a good compromise before splashing out loads of cash on a 
digital scope.

Using a clamp meter is pretty easy - you just get all the individual 
wires of a particular voltage for the power supply (e.g. all the yellow 
12v wires), and place the jaws of the clamp around those wires only - 
such that they are all "pointing the same way" i.e. the power-supply 
side is all on one side of the meter, and the power-consumers are all on 
the other side of the meter.

i.e.

PSU--------------+------------->Drive
PSU--------------+------------->Drive
PSU--------------+------------->Drive
PSU--------------+------------->Drive
PSU--------------+------------->Drive
PSU--------------+------------->Motherboard

with the clamp passed around the wires where the '+' is.

The DC current in the wires induces a circular magnetic field in the 
clamp jaws, and this in turn "bends" the average path of a small current 
across a flat piece of silicon inside the meter - because the path is no 
longer "straight across from A to B" in the silicon but instead takes a 
longer route: the stronger the magnetic field, the higher apparent 
resistance of the silicon (known as the "Hall effect").

... then you read off the measured current on the meter, check the spec 
sheet for the power supply (or sometimes the ratings sticker) to see 
what the max draw at 12v is, then repeat for 5v (red), 3.3v (orange) etc....

Tim.

-- 

South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

