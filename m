From: "jdd@dodin.org" <jdd@dodin.org>
Subject: Re: fixing raid1
Date: Mon, 1 May 2017 19:43:30 +0200
Message-ID: <a2ebd87b-52b2-3182-b9ff-fa2981dda558@dodin.org>
References: <c416bcba-7a5d-a409-42ca-2eb82eca32b7@dodin.org>
 <20170501221954.52b2dd76@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170501221954.52b2dd76@natsu>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le 01/05/2017 à 19:19, Roman Mamedov a écrit :

> It appears you just need to do the 2nd step as listed in that wiki,
>
>   mdadm --grow /dev/md127 --raid-devices=2
>
> Did you try it?


I didn't (grow... was thinking it was to make it bigger :-()

but it works perfectly

done

Thanks
jdd
