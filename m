From: "Matthew Elvey (munged)" <my-first-name@elvey.com>
Subject: Re: Flashing the drive activity light....  (was Re: solution and
 OT RAID news-story.)
Date: Mon, 09 Aug 2004 20:58:58 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41184802.60501@elvey.com>
References: <1091741886.5260.12.camel@HT.petrafex> <4113063E.5040801@elvey.com> <41135AC4.3060900@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41135AC4.3060900@buttersideup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/6/2004 3:17 AM, Tim Small sent forth electrons to convey:

> a utility to flash the activity light on a SCSI drive...
>
> Any ideas anyone?

Well, there are hardware raid devices that will flash the an amber or 
red LED to indicate failure, but that'll be specific to the device.
Flashing the activity light is easy to do with a self-rolled script, no?
#!/bin/sh
while true
do
    dd or copy to cause some access
    sleep 1
done
