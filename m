From: Alexander Shenkin <al@shenkin.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Wed, 11 Oct 2017 07:23:24 +0100
Message-ID: <21250e7e-f431-f894-4b62-c259687234fe@shenkin.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
 <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
 <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
 <CAC5BxnO9URNuE556Mi0DD=1knf7p0qb3frAGTJa=FK8TvJNxpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC5BxnO9URNuE556Mi0DD=1knf7p0qb3frAGTJa=FK8TvJNxpw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: josh <poddmo@gmail.com>
Cc: Reindl Harald <h.reindl@thelounge.net>, Phil Turmel <philip@turmel.org>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/2017 11:23 PM, josh wrote:
> This is indicative of a Debian/Ubuntu distribution. The cron entry is
> not enough to enable md array checks, you have to edit
> /etc/default/mdadm and set AUTOCHECK=true

Thanks Josh.  AUTOCHECK is indeed set to true in /etc/default/mdadm.

