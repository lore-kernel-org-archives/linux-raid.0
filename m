From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sun, 13 Jan 2013 12:18:58 -0700
Message-ID: <24DE0AA3-FAEF-4FF1-BAA5-B3A6B041C2B9@colorremedies.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301110520.07128.thomas@fjellstrom.ca> <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com> <201301111151.44384.thomas@fjellstrom.ca>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301111151.44384.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 11, 2013, at 11:51 AM, Thomas Fjellstrom <thomas@fjellstrom.ca> =
wrote:

> On Fri Jan 11, 2013, you wrote:
>> OK fair enough, and as asked earlier, what's the chunk size?
>=20
> Ah, sorry, I missed that bit. I didn't tweak the chunk size, so I hav=
e the=20
> default 512K.

OK now that the subject has been sufficiently detoured=85=20

Benchmarking can perhaps help you isolate causes for problems you're ha=
ving, but you haven't said what problems you're having.  You're using b=
enchmarking data to go looking for a problem. This is a GigE network to=
 the NAS? If it's wireless, who cares, all of these array numbers are b=
etter than wireless bandwidth and latency. If it's GigE, all of your se=
quential read write numbers exceed the bandwidth of wired. So what's th=
e problem? You want better random read writes? Rebuild the array with a=
 32KB or 64KB chunk size, knowing you may take a small hit on the large=
r sequential read/writes.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
