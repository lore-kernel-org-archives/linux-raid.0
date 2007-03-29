From: "Dirk Jagdmann" <jagdmann@gmail.com>
Subject: Re: split raid1 into to arrays
Date: Thu, 29 Mar 2007 12:01:39 +0200
Message-ID: <5d0f60990703290301o641abce4wb4e2b9e73afe7995@mail.gmail.com>
References: <5d0f60990703261954l2bb8c225ocbc3cf66e868723a@mail.gmail.com>
	 <46093ED8.8020201@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46093ED8.8020201@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The fast way (not redundant):
>   You can mark hdb as failed, then remove it. Then you can create a new
> array using hdb and a missing device.

Used this way and it worked.

-- 
---> Dirk Jagdmann
----> http://cubic.org/~doj
-----> http://llg.cubic.org
