From: Phil Turmel <philip@turmel.org>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Wed, 1 Mar 2017 13:13:13 -0500
Message-ID: <2d168cc1-cddc-5e0c-610b-97cbd08de621@turmel.org>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
 <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
 <20170224084024.4dfe83a2.ian_bruce@mail.ru>
 <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
 <c23b2aca-b6e6-37b8-3238-e59423d8f5a7@youngman.org.uk>
 <aee1f55b-cedf-15e9-5865-7fc0cdf9a188@turmel.org>
 <58B2137B.6070608@youngman.org.uk>
 <5172e2ab-e193-477b-52c4-86fbab0d52fe@turmel.org>
 <58B21987.6060604@youngman.org.uk>
 <657e80e9-b1f5-1f58-a4d0-6cbc4cc44927@turmel.org>
 <58B6E287.9020804@youngman.org.uk>
 <27373f29-a8ea-012c-102d-9fadf05cb3c2@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27373f29-a8ea-012c-102d-9fadf05cb3c2@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/2017 12:23 PM, Phil Turmel wrote:
> I strongly disagree.  This procedure, as shown, is an admin cock-up:
> 
>> mdadm --build /dev/mdbackup --device-count 2 /dev/md/home missing
>> ... hotplug sd-big ...
>> madam /dev/mdbackup --add /dev/sd-big
>> ... wait for sync to finish ...
>> mdadm --stop mdbackup
>> ... unplug sd-big ...

One more point.  The above is functionally identical in every respect
to just:

# dd if=/dev/md/home of=/dev/sd-big bs=1M

Why are you bothering to --build an array?

Phil

