From: maarten <maarten@ultratux.net>
Subject: Re: more mdadm questions
Date: Wed, 1 Sep 2004 02:33:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409010233.40062.maarten@ultratux.net>
References: <1093997605.3399.34.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1093997605.3399.34.camel@rich>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 01 September 2004 02:13, rich turner wrote:

Hi Rich,

Not wanting to be blunt an all...   but wouldn't most of these questions be 
answered by just running mdadm yourself...?

> when mdadm queries information about the raid devices, does it simply
> get the imformation from /proc/mdstat and format it accordingly?

My guess would be no, since /proc/mdstat gives less info than mdadm does.

> how does mdadm know what devices to query if they are not defined in
> /etc/mdadm/mdamd.conf with DEVICES?

Don't know how, but since 'mdadm --detail --scan' provides the info you can 
use to create the mdadm.conf file when missing, mdadm obviously does not rely 
on getting its info from that file at all. 

> if devices are missing from the raid device, is there a way of knowing
> the name of the missing device without the configuration file?

Yes.  Well, it depends on what you call "missing".  It will report a failed 
etc device, but if the array was created with a 'missing' drive it obviously 
cannot know what device will get added before you actually add it.

greetings,
Maarten

-- 


