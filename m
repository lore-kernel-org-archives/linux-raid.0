From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Wed, 28 Sep 2016 10:55:06 -0500
Message-ID: <b87f3f0d-e9a9-8ece-d708-9b8730157bfb@gmail.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
 <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
 <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
 <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
 <57EAA214.8030603@youngman.org.uk>
 <5427ce35-f222-8a2c-486e-441c4c6ec9a6@gmail.com>
 <be044941-8097-7d6f-5216-294fe2cac4d9@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <be044941-8097-7d6f-5216-294fe2cac4d9@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/27/2016 06:09 PM, Adam Goryachev wrote:
> Just out of interest, but I'm not sure how useful your munin monitoring will be... AFAIK, the mismatch_cnt value is only updated when you run a check, which would probably take some number of hours to complete. I would guess that you are unlikely to run more than one check a week or month.... and as soon as there is any change (unless you know the explanation) then you should be looking to resolve that.
>
> Unless of course I'm wrong about when the count is updated?

You would be correct - only during checks - but it's an easy way for me to just keep track of it..

And a check takes about 3hrs on this array. (and it happens every weekend)

 -Ben
