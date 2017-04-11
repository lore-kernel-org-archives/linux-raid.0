From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Shrinking an array
Date: Tue, 11 Apr 2017 11:58:47 +0500
Message-ID: <20170411115847.49560234@natsu>
References: <20170411003008.GA18538@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170411003008.GA18538@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 10 Apr 2017 20:30:08 -0400
Wakko Warner <wakko@animx.eu.org> wrote:

> I have less than 1tb actually in use.

I'd say just create a new array from scratch on new drives and copy data over.
Going to great lengths with all the layering to ensure proper and safe
shrinking on each is just wasted effort to babysit what is basically an empty
array.

-- 
With respect,
Roman
