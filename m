From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: mdadm 3.0.3 bug report
Date: Mon, 9 Nov 2009 16:24:35 -0800
Message-ID: <4877c76c0911091624u6afc98dt5367b55c35eb997c@mail.gmail.com>
References: <cccedfc60911090743m77b26b7bx98bf5d18b7e96311@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60911090743m77b26b7bx98bf5d18b7e96311@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

$ perror 1
OS error code   1:  Operation not permitted

Will it let you create that with another layout type? (such as near or
offset) or with another metadata container format (such as 1.1)?
