From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Why not just return an error?
Date: Fri, 7 Oct 2016 02:32:40 +0300
Message-ID: <57F6DF18.40703@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings!

The more I read about md-raid, the more I notice that the biggest 
problem of it: if you hit an error on a degraded RAID, it falls apart. 
Because of this, it is possible to lose a huge amount of data due to one 
tiny read error, which particularly makes raid5 the sword of Damocles.

But one question keeps me increasingly frustrated. Yes, during its 
normal functioning, it totally makes sense to kick a faulty device out 
of an array. But if we're running a degraded array, and doing so will 
definitely result is massive data loss, why not just return a read error 
instead? Just add a little check: on error, if degraded -> then just 
return an error. I believe this is the dream of everyone who had ever 
dealt with RAIDs.

With RAID, the first proprity is keeping data safe. Yes, it's not an 
alternative to backups and all that, but still - if we hit an error on a 
degraded array, the array should scream and panic and send all kinds of 
warnings, but definitely NOT collapse and warrant a visit to the RAID 
recovery laboratory (or this mailing list). Imagine how much headache 
and lost hair would that relieve!..

Now, I'm probably not the first one to think of such a bright idea. So 
there must be a very good reason why this is not possible; I don't think 
the problem is just that "the existing behaviour is preferred, and 
anyone who does not agree is an idiot". If not for enterprise use, then 
at least it would be very useful for the "home archive" scenario when 
"uptime" and "absense of errors" hold much less meaning than "losing one 
file and not all the data". So, why is this not possible?..


-- 
darkpenguin
