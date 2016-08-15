From: Chris Murphy <lists@colorremedies.com>
Subject: Re: read errors with md RAID5 array
Date: Mon, 15 Aug 2016 07:57:56 -0600
Message-ID: <CAJCQCtSggAsQMSH9Ufa=Vjmu13cBm58+Q-RBZ4WRXm9UF=Yd+Q@mail.gmail.com>
References: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

$ sudo smartctl -l scterc <dev>   ## for each device used in the array
$ sudo cat /sys/block/<dev>/device/timeout   ## for each device used
in the array


Chris Murphy
