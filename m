From: Drew <drew.kay@gmail.com>
Subject: Re: Disk Monitoring
Date: Sat, 1 Jul 2017 06:42:02 -0700
Message-ID: <CACJz6Quin5jReORQMk_-30yBq6MhmBYoO8S_3yw+OEqBwYiAww@mail.gmail.com>
References: <20170628131917.BF1911235B6@gemini.denx.de> <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <2113365.0QvyMCaQ9I@matkor-lenovo> <CAJH6TXiONYigcX1CtQw86ZXUgeOLvzD_+2couNfxSwL9hHj1gA@mail.gmail.com>
 <59550FCB.4090508@youngman.org.uk> <CAJH6TXg+xf0giY5bC_ug4jm+t88LzHkTVJq_BYeYzxEKedF2OA@mail.gmail.com>
 <94fcf340-4924-2f01-e616-a9b6ba172459@turmel.org> <faaa61f1-da3c-036b-e6b0-1107759e1c1d@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <faaa61f1-da3c-036b-e6b0-1107759e1c1d@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jun 30, 2017 at 12:56 PM, Anthony Youngman
<antlists@youngman.org.uk> wrote:
> On 30/06/17 15:35, Phil Turmel wrote:
>>
>> The only good reason for hardware raid, in my opinion.  Balanced against
>> vendor lock-in, limited layout options, and a plethora of management
>> interfaces.
>
>
> And lost data when your controller quits, and you can't find another one
> that implements the same sort of raid ...

Back in the days of SCSI that was very true but ..

In the defense of the hw raid vendor I've worked with quite a bit
(LSI), I've found you can migrate RAID arrays from controller to
controller quite easily. So if your raid controller fails, you can
always grab the current available controller that supports your
required raid level. I've created arrays in the older 1068 controller
(PCI-X card) and easily migrated it to a newer 2008 or 2108 based
controller with no fuss. See's the older array as an 'external' array
and imports just fine.


-- 
Drew
