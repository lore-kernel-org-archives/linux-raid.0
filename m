From: Iustin Pop <iusty@k1024.org>
Subject: Re: Doubt
Date: Thu, 5 Nov 2009 08:38:29 +0100
Message-ID: <20091105073829.GA20678@teal.hq.k1024.org>
References: <d3540f4d0911042326o754d5f06qf958d8ab5b309e86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d3540f4d0911042326o754d5f06qf958d8ab5b309e86@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Light King <thelightking@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 05, 2009 at 12:56:30PM +0530, Light King wrote:
> So we dont want any kind of data recovery in our raid device (like
> raid0) but we want if one cf card failed also, the raid device should
> run or should reactive without any error(like raid10) but we should
> abel to use the total disk space (like raid0).

Uh... you don't want to use any space for redundancy but you want redundancy??

iustin
