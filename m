From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Fri, 11 Jan 2013 16:17:58 -0600
Message-ID: <50F08F96.1050909@hardwarefreak.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301110520.07128.thomas@fjellstrom.ca> <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com> <201301111151.44384.thomas@fjellstrom.ca>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301111151.44384.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/11/2013 12:51 PM, Thomas Fjellstrom wrote:

>> It's not but as Stan writes it may not be preferred for your application.
> 
> Hm, ok, it is in my mount line, so I'll try it with that off. Though I would 
> be interested in hearing from Stan why it may not be good.

You should not do this.  This parameter is not a toggle switch intended
to be flipped on/off at will, but changed only once and left there.

Never change XFS parameters willy-nilly without knowing the
consequences.  And currently you certainly do not know them.

I don't have time for the detailed explanation.  Ask on the XFS list.

-- 
Stan

