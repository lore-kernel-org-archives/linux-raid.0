From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: Convert raid5 to raid1?
Date: Thu, 10 Mar 2005 23:34:14 +0100
Message-ID: <4230CB66.8030705@weisshuhn.de>
References: <4230BE56.6090905@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4230BE56.6090905@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: John McMonagle <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John McMonagle wrote:

> Just wonder what happens to the md sequence when I remove the original 
> raid arrays?
> When I'm done will I have md0,md1 and md2 or  md2,md3 and md4?

they will have the name you entered when you created the array.
after removing one array from the system all arrays will still have 
their original device-number after reboot.

greetings,
frank
