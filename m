From: Arshavir Grigorian <ag@m-cam.com>
Subject: Re: Add a spare to raid5 array?
Date: Fri, 11 Mar 2005 15:41:10 -0500
Message-ID: <42320266.2040901@m-cam.com>
References: <422FA1F8.4020709@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <422FA1F8.4020709@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: John McMonagle <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John McMonagle wrote:
> Can  a  spare be added to an existing raid 5 array?
> 
> I do not see any way to do it.
> 
> John
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

How about mdadm --add?

Arshavir

